protoc -I=sourcedir --ts_out ./frontend/src --proto_path messages messages/*.proto
protoc --proto_path=./messages --go_out=./ messages/*.proto
