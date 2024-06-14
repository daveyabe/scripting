import boto3

aether.PRODLAMBDA = True

from aether.api import AetherAPI

def get_rca_map(rca_barcode):

    rca_addres_to_info = {}

    params = {'barcode': rca_barcode}
    result = ProjectAPI.PlatePlasmidToEnzymeContents.execute(params=params)
    data = result.as_json()
    data = data['plateByBarcode']

    for edge in data['wells']['edges']:
        well_info = {}

        if edge['node']['plasmid'] == None:
            continue

        address = edge['node']['address']
        well_info['well_id'] = edge['node']['id']
        well_info['plasmid_id'] = edge['node']['plasmid']['id']
        well_info['enzyme_id'] = edge['node']['plasmid']['gene']['expressedEnzyme']['id']
        rca_addres_to_info[address] = well_info

    return rca_addres_to_info


def get_address_to_ids(plate_barcode):

    params = {
        "barcode": plate_barcode
    }

    result = ProjectAPI.PlateWellsByBarcode.execute(params=params)
    data = result.as_json()
    plate = data['plateByBarcode']
    address_to_ids = {}

    for well in plate['wells']['edges']:
            address_to_ids[well['node']['address']] = well['node']['id']

    return address_to_ids


def lambda_handler(event, context):

    s3_client = boto3.client('s3')

    bucket = event['Records'][0]['s3']['bucket']['name']
    key = event['Records'][0]['s3']['object']['key']
    print(f'bucket: {bucket}')
    print(f'key: {key}')

    input_file = s3_client.get_object(Bucket = bucket, Key = key)
    input_content = input_file['Body'].read().decode('utf-8')
    
    lines = input_content.splitlines()

    parts = lines[1].replace('"', '').split(',')
    rca_barcode = parts[4].strip()
    print(f'1 Plate Barcode: {rca_barcode}')
    rca_map = get_rca_map(rca_barcode)

    txtl_barcode = parts[1].strip()
    print(f'2 Plate Barcode: {txtl_barcode}')
    txtl_map = get_address_to_ids(txtl_barcode)

    assemblies = []

    for line in lines:
        if 'RecordID' in line:
            continue #skip first line

        parts = line.replace('"', '').split(',')
        destination_well_address = parts[2]
        source_well_address = parts[5]
        volume = parts[3]

        if source_well_address not in rca_map:
            continue

        well_info = rca_map[source_well_address]

        source_input = [
             {
                  'sourceWellId': well_info['well_id'],
                  'volume': volume,
                  'volumeUnit': 'uL',
             }
        ]

        assemblies.append(
             {
                  'fragments': source_input,
                  'destinationWellId': txtl_map[destination_well_address],
                  'destinationIngredientId': well_info['enzyme_id']
             }
        )

    params = {
         'input': {
              'assemblies': assemblies
         }
    }

    result = ProjectAPI.TransmuteDnaFragments.execute(params=params)
    data = result.as_json()
    print(data)
