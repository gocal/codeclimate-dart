FROM google/dart AS dart-runtime

WORKDIR /app

RUN git clone --depth 1 --branch 2.1.0 https://github.com/wrike/dart-code-metrics.git /app
RUN pub get
RUN dart2native /app/bin/metrics.dart -o /app/metrics

FROM bitnami/minideb
RUN adduser -u 9000 --disabled-password app
WORKDIR /app
COPY engine.json ./

COPY --from=dart-runtime /app/metrics /metrics

USER app

VOLUME /code
WORKDIR /code

CMD []
ENTRYPOINT ["/metrics", "--reporter=codeclimate", "--ignore-files={/**.g.dart,/**.template.dart,.dart-tool,.git,_build}", "./"]
