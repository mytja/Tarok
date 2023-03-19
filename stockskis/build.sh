export CGO_ENABLED=1
go build -o libstockskis.so -buildmode=c-shared -v stockskis
