FROM alpine AS build
ARG TARGETARCH
ARG VERSION=dev
RUN echo "hello on $TARGETARCH (version: $VERSION)" > /hello

FROM scratch
ARG VERSION=dev
LABEL org.opencontainers.image.title="gha-test" \
      org.opencontainers.image.version="${VERSION}"
COPY --from=build /hello /hello
