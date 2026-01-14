# Stage 1: Build
FROM node:20-alpine AS build

WORKDIR /app

RUN npm install -g pnpm

COPY package.json pnpm-lock.yaml ./
RUN pnpm install --frozen-lockfile

COPY . .

ARG REACT_APP_CLIENT_SECRET
ENV REACT_APP_CLIENT_SECRET=$REACT_APP_CLIENT_SECRET

ARG REACT_APP_CLIENT_ID
ENV REACT_APP_CLIENT_ID=$REACT_APP_CLIENT_ID

RUN pnpm run build

# Stage 2: Production
FROM nginx:stable-alpine

COPY --from=build /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
