FROM python:3.11
RUN useradd -m -u 1000 user
USER user
ENV HOME=/home/user \
    PATH=/home/user/.local/bin:$PATH
WORKDIR $HOME/app
COPY --chown=user . $HOME/app
COPY ./requirements.txt ~/app/requirements.txt
RUN pip install -r requirements.txt

RUN mkdir $HOME/tmp
RUN mkdir $HOME/app/policy_rag
RUN git clone https://github.com/ledgerW/policy-rag.git $HOME/tmp
COPY --chown=user $HOME/tmp/policy-rag/policy_rag $HOME/app/policy_rag
RUN rm -rf $HOME/tmp

COPY . .
CMD ["chainlit", "run", "app.py", "--port", "7860"]