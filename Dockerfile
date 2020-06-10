FROM ruby:2.6.1

RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
RUN gem install bundler -v 2.0.1

RUN mkdir /rezzemay-api
WORKDIR /rezzemay-api

COPY Gemfile /rezzemay-api/Gemfile
COPY Gemfile.lock /rezzemay-api/Gemfile.lock

RUN bundle install

COPY . /rezzemay-api

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]