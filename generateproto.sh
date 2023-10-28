mkdir -p ./tarok/lib/messages
protoc --dart_out ./tarok/lib/messages --proto_path messages messages/*.proto
protoc --proto_path=./messages --go_out=./ messages/*.proto
