FROM python:3.11
RUN useradd -m -u 1000 user
USER user
ENV HOME=/home/user \
    PATH=/home/user/.local/bin:$PATH
WORKDIR $HOME/app
COPY --chown=user . $HOME/app
COPY ./requirements.txt ~/app/requirements.txt
RUN pip install -r requirements.txt

RUN mkdir tmp
RUN mkdir ~/app/policy-rag
RUN git clone https://github.com/ledgerW/policy-rag.git tmp
COPY --chown=user ./tmp/policy-rag/policy-rag ~/app/policy-rag
RUN rm -rf ./tmp

COPY . .
CMD ["chainlit", "run", "app.py", "--port", "7860"]