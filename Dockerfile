FROM node:20-alpine AS build

WORKDIR /build
COPY package.json package-lock.json ./
RUN npm install

COPY . .
RUN npm run build

FROM node:20-alpine AS prod

WORKDIR /app

COPY --from=build /build/dist ./dist
COPY --from=build /build/node_modules ./node_modules
COPY --from=build /build/package.json .
COPY --from=build /build/tsconfig.json .

EXPOSE 4000

CMD [ "npm", "run", "start:prod" ]
