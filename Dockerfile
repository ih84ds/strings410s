ARG node_version=12.16.1

###
# DEVELOPMENT IMAGE
#
# This image has no code baked in since the code will be mounted into it
# by docker-comopse.
###

# Locking to a specific version to avoid version compatibility issues
FROM node:${node_version} as development

# Set to a non-root built-in user `node`
USER node
ENV HOST=0.0.0.0 PORT=8080
EXPOSE ${PORT}

###
# BUILDER IMAGE
#
# This builds upon the development image, installs modules, and
# builds the code
###

FROM development as builder

# Create app directory (with user `node`)
RUN mkdir -p /home/node/app

WORKDIR /home/node/app

# Install app dependencies
COPY --chown=node package.json yarn.lock ./

# TODO: use multistage build for production and only install production modules
RUN yarn install

# Bundle app source code
COPY --chown=node . .

RUN yarn build

CMD [ "yarn", "start" ]
