# StockŠkis

StockŠkis je "engine" za tarok, skrbi za naključno mešanje in upravlja bote.

StockŠkis je bil spisan v Dartu z namenom v uporabi Palčka tarok programu. Dart je uporabljen za boljšo integracijo z aplikacijo (|| ni se mi dalo pisati Dart FFI-ja, saj je to pain, drugače bi bil napisan v Go-ju. ||). Kljub temu da Dart kode očitno ne moreš klicati iz drugih jezikov, ponuja StockŠkis tudi CLI, preko katerega kliče tudi `stockskis.go`, tj. Go implementacija StockŠkisa.

StockŠkis je trenutno v zgodnji alfa fazi in verjetno ne igra tako dobro kot ostali (zaprtokodni) engini, ampak to nameravam izboljšati čez čas. Po mojih (zelo strokovno narejenih, no cap fr fr) tržnih raziskavah je StockŠkis trenutno eden izmed redkih odprtokodnih tarok enginov, posebej narejen za slovenski tarok.

## Licenca

GPLv3 ali kasnejša licenca. Celotno besedilo licence je na voljo v datoteki `LICENSE`.
