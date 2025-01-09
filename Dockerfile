#
#	MetaCall NodeJS C io_uring Example by Parra Studios
#	An example of embedding io_uring (from C) into NodeJS.
#
#	Copyright (C) 2016 - 2021 Vicente Eduardo Ferrer Garcia <vic798@gmail.com>
#
#	Licensed under the Apache License, Version 2.0 (the "License");
#	you may not use this file except in compliance with the License.
#	You may obtain a copy of the License at
#
#		http://www.apache.org/licenses/LICENSE-2.0
#
#	Unless required by applicable law or agreed to in writing, software
#	distributed under the License is distributed on an "AS IS" BASIS,
#	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#	See the License for the specific language governing permissions and
#	limitations under the License.
#

FROM debian:trixie-slim

# Image descriptor
LABEL copyright.name="Vicente Eduardo Ferrer Garcia" \
	copyright.address="vic798@gmail.com" \
	maintainer.name="Vicente Eduardo Ferrer Garcia" \
	maintainer.address="vic798@gmail.com" \
	vendor="MetaCall Inc." \
	version="0.1"

# Install dependencies
RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		ca-certificates \
		git \
		liburing-dev

# Set working directory to root
WORKDIR /root

# Clone and build the project
RUN git clone --branch v0.8.7 https://github.com/metacall/core \
	&& mkdir core/build && cd core/build \
	&& ../tools/metacall-environment.sh release base nodejs c \
	&& ../tools/metacall-configure.sh release nodejs c ports install \
	&& ../tools/metacall-build.sh release nodejs c ports install \
	&& cd ../.. \
	&& rm -rf core

# Copy source files
COPY index.js /root/
COPY public /root/public
COPY scripts/uring.c scripts/script.ld /home/scripts/

# Set up enviroment variables
ENV LOADER_LIBRARY_PATH=/usr/local/lib \
	LOADER_SCRIPT_PATH=/home/scripts

EXPOSE 28977

# HEALTHCHECK --interval=1s --timeout=3s --start-period=1ms \
# 	CMD curl localhost:28977 || exit 1

CMD [ "metacallcli", "/root/index.js" ]
