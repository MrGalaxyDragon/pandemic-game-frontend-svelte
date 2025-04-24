FROM node:22-alpine AS build
WORKDIR /app
COPY package*.json .
RUN npm ci
COPY . .
RUN npm run build
RUN npm prune --production

FROM node:22-alpine
WORKDIR /app
COPY --from=build /app/build build/
COPY --from=build /app/node_modules node_modules/
COPY package.json .
ENV NODE_ENV=production
ENV PORT=5173
EXPOSE 5173
CMD [ "node", "build" ]