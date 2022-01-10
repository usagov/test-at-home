FROM cimg/ruby:3.0.3-node

ENV PORT=3000
EXPOSE $PORT

COPY --chown=circleci . /home/circleci/project
RUN bundle install --deployment
RUN yarn install --frozen-lockfile

ENV RAILS_ENV=ci
RUN bundle exec rake assets:precompile

CMD ["./bin/ci-server-start"]
