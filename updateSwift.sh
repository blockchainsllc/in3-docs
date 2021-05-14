#!/bin/sh
cd ../in3-swift
rm -rf .build/documentation/* 
swift doc generate . --module-name In3
rm -rf .build/documentation/_* .build/documentation/Home.md ".build/documentation/allTests().md"
res=../in3-doc/docs/api-swift.md 
cat > $res <<- EOM 
# API Reference Swift

The swift binding for incubed are deployed as Swift Package containing the source file in C and in Swift.

## Install

Add the Incubed Package as dependency to your project in your Package.swift :

\`\`\`swift
dependencies: [
    .package(url: "https://github.com/blockchainsllc/in3-swift.git", .branch("master"))
],
\`\`\`

## Usage

In order to use incubed, you need to add the In3-Package as dependency and import into your code:

\`\`\`swift
import In3

// configure and create a client.
let in3 = try In3Config(chainId: "mainnet", requestCount:1).createClient()

// use the Eth-Api to execute requests
in3.eth.getTransactionReceipt(hash: "0xe3f6f3a73bccd73b77a7b9e9096fe07b9341e7d1d8f1ad8b8e5207f2fe349fa0").observe(using: {
            switch $0 {
            case let .failure(err):
                print("Failed to get the tx : \(err)")
            case let .success( tx ):
                if let tx = tx {
                    print("Found tx with txhash \(tx.hash)")
                } else {
                    print("Tx does not exist")
                }
            }
        })
\`\`\`

EOM

addFolder() 
{
   echo "## $2"  >> $res
   for n in $3 `cat Sources/In3/${1}*.swift | grep "public class \|public struct\|public protocol" | grep -v "    " | sed -E -e 's/public|class|protocol|struct|final|\{//g' | sed -E -e 's/:.*//g' | sed -E -e 's/<.*//g' | sort -V | grep -v "$3 \$"`; do
      cat .build/documentation/$n.md  .build/documentation/${n}_*.md 2>/dev/null | sed 's/^## .*//' | sed 's/^#### \(.*\)/**\1**/' | sed 's/^### \`\(.*\)\`/### \1/' | sed 's/^### /#### /' | sed 's/^# /### /' >> $res 
   done;
}

addFolder ./ SDK SDK
for f in `ls Sources/In3/API/*.swift | sort -V | sed 's/.swift//' | sed -E -e 's/.*\///'` ; do 
  addFolder "API/$f" "API $f" $f
done;
addFolder Utils/ Utils _

cd ../in3-doc
