FROM python:3.11

# Create a user and set environment variables
RUN useradd -m -u 1000 user
USER user
ENV HOME=/home/user \
    PATH=/home/user/.local/bin:$PATH

# Set working directory
WORKDIR $HOME/app

# Copy the application files
COPY --chown=user . $HOME/app
COPY ./requirements.txt $HOME/app/requirements.txt

# Install Python dependencies
RUN pip install -r requirements.txt

# Switch to root user for privileged operations
USER root

# Create necessary directories
RUN mkdir -p $HOME/tmp
RUN mkdir -p $HOME/app/policy_rag

# Clone the repository as root
RUN git clone https://github.com/ledgerW/policy-rag.git $HOME/tmp/policy_rag

# Copy cloned repository to the final destination
RUN cp -r $HOME/tmp/policy_rag/* $HOME/app/policy_rag

# Clean up temporary files
RUN rm -rf $HOME/tmp

# Switch back to non-root user
USER user

# Add the policy_rag directory to the PYTHONPATH
ENV PYTHONPATH=$PYTHONPATH:/home/user/app/policy_rag

# Copy application files and set the command to run the app
COPY . .
CMD ["chainlit", "run", "app.py", "--port", "7860"]
