FROM python:3.5.3-jessie

RUN pip install http://download.pytorch.org/whl/cu75/torch-0.1.12.post2-cp35-cp35m-linux_x86_64.whl \
 && pip install torchvision

#RUN pip install http://download.pytorch.org/whl/cu75/torch-0.1.12.post2-cp36-cp36m-linux_x86_64.whl
#RUN pip install torchvision

RUN git clone https://github.com/facebookresearch/DrQA.git \
  && cd DrQA; pip install -r requirements.txt; python setup.py develop
WORKDIR DrQA

# If you use the CoreNLPTokenizer or SpacyTokenizer
RUN apt-get update && apt-get install -y unzip sed
COPY stanford-corenlp-full-2017-06-09.zip /tmp/stanford-corenlp-full-2017-06-09.zip
RUN sed -i -e 's!^wget -O "stanford-corenlp-full-2017-06-09.zip" "http://nlp.stanford.edu/software/stanford-corenlp-full-2017-06-09.zip"$!!' ./install_corenlp.sh
RUN echo corenlp > input \
  && echo yes >> input
RUN cat input | ./install_corenlp.sh

# TODO delete 2 lines
COPY java-8-openjdk-amd64/ ./
RUN ln -s ./java-8-openjdk-amd64/jre/bin/java* /usr/bin/java

# 7.5GB
COPY fair-data_drqa_data.tar.gz ./data.tar.gz
RUN sed -i -e 's!^wget -O "$DOWNLOAD_PATH_TAR" "https://s3.amazonaws.com/fair-data/drqa/data.tar.gz"$!!' ./download.sh

# RUN ./download.sh
COPY WebQuestions-train.json.bz2 ./data/datasets/WebQuestions-train.json.bz2
RUN sed -i -e 's!^wget -O "$DATASET_PATH/WebQuestions-train.json.bz2" "http://nlp.stanford.edu/static/software/sempre/release-emnlp2013/lib/data/webquestions/dataset_11/webquestions.examples.train.json.bz2"$!!' ./download.sh
COPY WebQuestions-test.json.bz2 ./data/datasets/WebQuestions-test.json.bz2
RUN sed -i -e 's!^wget -O "$DATASET_PATH/WebQuestions-test.json.bz2" "http://nlp.stanford.edu/static/software/sempre/release-emnlp2013/lib/data/webquestions/dataset_11/webquestions.examples.test.json.bz2"$!!' ./download.sh
COPY freebase-entities.txt.gz ./data/datasets/freebase-entities.txt.gz
RUN sed -i -e 's!^wget -O "$DATASET_PATH/freebase-entities.txt.gz" "https://s3.amazonaws.com/fair-data/drqa/freebase-entities.txt.gz"$!!' ./download.sh

# TODO merge to apt above
COPY SQuAD-v1.1-train.json ./data/datasets/SQuAD-v1.1-train.json
COPY SQuAD-v1.1-dev.json ./data/datasets/SQuAD-v1.1-dev.json
COPY CuratedTrec-test.txt ./data/datasets/CuratedTrec-test.txt
COPY CuratedTrec-train.txt ./data/datasets/CuratedTrec-train.txt
RUN mkdir ./data/wikipedia ./data/reader
COPY docs-tfidf-ngram=2-hash=16777216-tokenizer=simple.npz.gz ./data/wikipedia/docs-tfidf-ngram=2-hash=16777216-tokenizer=simple.npz.gz
COPY docs.db.gz ./data/wikipedia/docs.db.gz
COPY multitask.mdl ./data/reader/multitask.mdl
COPY single.mdl ./data/reader/single.mdl
RUN gunzip ./data/wikipedia/docs-tfidf-ngram=2-hash=16777216-tokenizer=simple.npz.gz \
  && gunzip ./data/wikipedia/docs.db.gz

# TODO merge to above
RUN rm /usr/bin/java
COPY java-8-openjdk-amd64/ /DrQA/java-8-openjdk-amd64
RUN ln -s /DrQA/java-8-openjdk-amd64/jre/bin/java* /usr/bin/java

# TODO replace ./ to /DrQA/

CMD ["/bin/bash"]
