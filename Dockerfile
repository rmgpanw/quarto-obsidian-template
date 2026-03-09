FROM rocker/r-ver:4.4.0

# System dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    gdebi-core \
    pandoc \
    && rm -rf /var/lib/apt/lists/*

# Install Quarto
ARG QUARTO_VERSION=1.6.42
RUN curl -fsSL -o quarto.deb "https://github.com/quarto-dev/quarto-cli/releases/download/v${QUARTO_VERSION}/quarto-${QUARTO_VERSION}-linux-amd64.deb" \
    && gdebi -n quarto.deb \
    && rm quarto.deb

# Install minimal R packages for Quarto rendering
RUN R -e 'install.packages(c("rmarkdown", "knitr"), repos = "https://cloud.r-project.org")'

WORKDIR /workspace
