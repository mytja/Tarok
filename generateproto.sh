protoc --proto_path=messages --js_out=import_style=commonjs,binary:./frontend/src messages/*.proto
protoc --proto_path=./messages --go_out=./ messages/*.proto
