curl -X POST \
    -H 'Content-type: application/json; charset=utf-8' \
    --data '{ "channel": "#devops", "username": "SOMEBOT", "icon_emoji": ":bot:", "text": "Foo" }' \
    https://hooks.slack.com/services/T/B/QR

curl -X POST -H 'Content-type: application/json' --data '{"text":"Hello, World!"}' https://hooks.slack.com/services/T/B/QR
