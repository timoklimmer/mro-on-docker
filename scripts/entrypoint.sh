#!/bin/bash
set -e
exec /usr/bin/Rscript -e "shiny::runApp(appDir='/shiny-app', host='0.0.0.0', port=80)"

