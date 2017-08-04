# how to use
## not using network for heavy files
### if you don't use network for heavy files, place below files in the same directory with Dockerfile before build.
- stanford-corenlp-full-2017-06-09.zip
- fair-data_drqa_data.tar.gz
- WebQuestions-train.json.bz2
- WebQuestions-test.json.bz2
- freebase-entities.txt.gz
- SQuAD-v1.1-train.json
- SQuAD-v1.1-dev.json
- CuratedTrec-test.txt
- CuratedTrec-train.txt
- docs-tfidf-ngram=2-hash=16777216-tokenizer=simple.npz.gz
- docs.db.gz
- multitask.mdl
- single.mdl
- java-8-openjdk-amd64
### if you don't place the files above, plese comment-out COPY and RUN-sed in Dockerfile.
### then, build and run
% docker build -t drqa .
% docker run -it drqa /bin/bash 
### follow "Quick Start: Demo" on the original repository.
https://github.com/facebookresearch/DrQA#quick-start-demo
