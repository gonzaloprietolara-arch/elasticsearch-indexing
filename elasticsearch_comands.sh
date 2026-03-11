#!/bin/bash

set -e

ES_URL="http://localhost:9200"
INDEX_NAME="pizzasmilan"
DATASET_FILE="pizzasmilan.dataset.json"

# COMPROBAR QUE ELASTICSEARCH ESTÁ ARRANCADO
curl -XGET "${ES_URL}/"

# CREAR EL ÍNDICE CON EL TYPE Y CAMPOS
curl -XPUT "${ES_URL}/${INDEX_NAME}" \
  -H 'Content-Type: application/json' \
  -d '{
    "mappings": {
      "pizzas": {
        "properties": {
          "NombrePizza": { "type": "text" },
          "Toppings":    { "type": "text" },
          "Masa":        { "type": "text" },
          "Tipo":        { "type": "text" },
          "Precio":      { "type": "integer" }
        }
      }
    }
  }'

# CARGAR LOS DATOS DESDE pizzasmilan.dataset.json
curl -XPOST "${ES_URL}/${INDEX_NAME}/_bulk?pretty" \
  -H 'Content-Type: application/json' \
  --data-binary @"${DATASET_FILE}"

# CONTAR LOS DOCUMENTOS INSERTADOS
curl -XGET "${ES_URL}/${INDEX_NAME}/_count?pretty"

# BUSCAR PIZZAS ENTRE 7 Y 9 EUROS
curl -XGET "${ES_URL}/${INDEX_NAME}/_search?pretty" \
  -H 'Content-Type: application/json' \
  -d '{
    "query": {
      "range": {
        "Precio": {
          "gte": 7,
          "lte": 9
        }
      }
    }
  }'

# BUSCAR PIZZAS CON MASA GRUESA
curl -XGET "${ES_URL}/${INDEX_NAME}/_search?pretty" \
  -H 'Content-Type: application/json' \
  -d '{
    "query": {
      "term": { "Masa": "gruesa" }
    }
  }'

# LOCALIZAR LA PIZZA MÁS BARATA PARA OBTENER SU _id
curl -XGET "${ES_URL}/${INDEX_NAME}/_search?pretty" \
  -H 'Content-Type: application/json' \
  -d '{
    "size": 1,
    "sort": [
      { "Precio": "asc" }
    ]
  }'

# IMPORTANTE:
# Sustituir ID_PIZZA_MAS_BARATA por el _id real obtenido en la consulta anterior
# y reducir su precio en un euro.
curl -XPOST "${ES_URL}/${INDEX_NAME}/pizzas/ID_PIZZA_MAS_BARATA/_update?pretty" \
  -H 'Content-Type: application/json' \
  -d '{
    "doc": {
      "Precio": 2
    }
  }'

# BUSCAR LA PIZZA MADRID DE TIPO MEDIA PARA OBTENER SU _id
curl -XGET "${ES_URL}/${INDEX_NAME}/_search?pretty" \
  -H 'Content-Type: application/json' \
  -d '{
    "query": {
      "bool": {
        "must": [
          { "term": { "NombrePizza": "Madrid" } },
          { "term": { "Tipo": "Media" } }
        ]
      }
    }
  }'

# IMPORTANTE:
# Sustituir ID_PIZZA_MADRID_MEDIA por el _id real obtenido en la consulta anterior
curl -XDELETE "${ES_URL}/${INDEX_NAME}/pizzas/ID_PIZZA_MADRID_MEDIA?pretty"

# COMPROBAR QUE LA PIZZA HA SIDO BORRADA
curl -XGET "${ES_URL}/${INDEX_NAME}/_search?pretty" \
  -H 'Content-Type: application/json' \
  -d '{
    "query": {
      "bool": {
        "must": [
          { "term": { "NombrePizza": "madrid" } },
          { "term": { "Tipo": "media" } }
        ]
      }
    }
  }'