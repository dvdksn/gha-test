FROM alpine AS build
ARG TARGETARCH
RUN echo "hello on $TARGETARCH" > /hello

FROM scratch
COPY --from=build /hello /hello
