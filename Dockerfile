FROM rocker/shiny

COPY . /app

WORKDIR /app

RUN apt-get update && apt-get install -y dotnet-runtime-8.0 libcurl4-openssl-dev libssl-dev libxml2-dev
RUN apt-get install -y libfontconfig1-dev libharfbuzz-dev libfribidi-dev
RUN apt-get install -y libfreetype6-dev libpng-dev libtiff5-dev libjpeg-dev

RUN ln -s /usr/lib/x86_64-linux-gnu/libdl.so.2 /usr/lib/x86_64-linux-gnu/libdl.so

RUN apt-get install -y git

RUN R -e "options(renv.config.repos.override = 'https://packagemanager.posit.co/cran/latest'); \
          renv::restore()"


EXPOSE 3838

CMD ["Rscript", "/app/app.R"]
