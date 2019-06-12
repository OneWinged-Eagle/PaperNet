# PaperNet

Following the [Hyperledger Fabric commercial paper tutorial](https://hyperledger-fabric.readthedocs.io/en/release-1.4/tutorial/commercial_paper.html), I made some very minor adjustements so I can call the issue / buy / redeem directly via a website running on expressjs.
It's cheap, dirty and not secure at all, but I just wanted to see how to decouple front and back.

Anyway, next steps are:

  - Add new organisation(s) directly in the setup
  - Add new organisation(s) while the blockchain is already running
  - Maybe take a deeper look into Raft and private data?
  - Not directly related to this, but try a bit the [IBM's marbles' blockchain](https://github.com/IBM-Blockchain/marbles) after I'm "done" with PaperNet
