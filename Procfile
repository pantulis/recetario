web: bundle exec puma -t 5:5 -p ${PORT:-3000} -e ${RACK_ENV:-production} 
console: bin/rails console
resque: env TERM_CHILD=1 QUEUE=* bundle exec rake environment resque:work
