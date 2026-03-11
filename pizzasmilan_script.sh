#!/bin/bash

echo "======================================"
echo "1. COMPROBAR QUE ELASTICSEARCH ESTÁ ARRANCADO"
echo "======================================"
curl -XGET 'http://localhost:9200/'

echo
echo "======================================"
echo "2. CREAR EL ÍNDICE CON TYPE Y CAMPOS"
echo "======================================"
curl -XPUT 'http://localhost:9200/pizzasmilan' \
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

echo
echo "======================================"
echo "3. CARGAR LOS DATOS DESDE pizzasmilan.dataset.json"
echo "======================================"
cd /home/code/materialcurso || exit

curl -XPOST 'http://localhost:9200/pizzasmilan/_bulk?pretty' \
  -H 'Content-Type: application/json' \
  --data-binary @pizzasmilan.dataset.json

echo
echo "======================================"
echo "4. CONTAR LOS DOCUMENTOS INSERTADOS"
echo "======================================"
curl -XGET 'http://localhost:9200/pizzasmilan/_count?pretty'

echo
echo "======================================"
echo "5. BUSCAR PIZZAS ENTRE 7 Y 9 EUROS"
echo "======================================"
curl -XGET 'http://localhost:9200/pizzasmilan/_search?pretty' \
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

echo
echo "======================================"
echo "6. BUSCAR PIZZAS CON MASA GRUESA"
echo "======================================"
curl -XGET 'http://localhost:9200/pizzasmilan/_search?pretty' \
  -H 'Content-Type: application/json' \
  -d '{
    "query": {
      "term": { "Masa": "gruesa" }
    }
  }'

echo
echo "======================================"
echo "7. LOCALIZAR LA PIZZA MÁS BARATA"
echo "======================================"
curl -XGET 'http://localhost:9200/pizzasmilan/_search?pretty' \
  -H 'Content-Type: application/json' \
  -d '{
    "size": 1,
    "sort": [
      { "Precio": "asc" }
    ]
  }'

echo
echo "======================================"
echo "8. ACTUALIZAR LA PIZZA MÁS BARATA"
echo "Sustituye ID_PIZZA_MAS_BARATA por el _id real"
echo "======================================"
curl -XPOST 'http://localhost:9200/pizzasmilan/pizzas/ID_PIZZA_MAS_BARATA/_update?pretty' \
  -H 'Content-Type: application/json' \
  -d '{
    "doc": {
      "Precio": 2
    }
  }'

echo
echo "======================================"
echo "9. BUSCAR LA PIZZA MADRID DE TIPO MEDIA"
echo "======================================"
curl -XGET 'http://localhost:9200/pizzasmilan/_search?pretty' \
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

echo
echo "======================================"
echo "10. BORRAR LA PIZZA MADRID MEDIA"
echo "Sustituye ID_PIZZA_MADRID_MEDIA por el _id real"
echo "======================================"
curl -XDELETE 'http://localhost:9200/pizzasmilan/pizzas/ID_PIZZA_MADRID_MEDIA?pretty'

echo
echo "======================================"
echo "11. COMPROBAR QUE LA PIZZA HA SIDO BORRADA"
echo "======================================"
curl -XGET 'http://localhost:9200/pizzasmilan/_search?pretty' \
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

echo
echo "======================================"
echo "FIN DEL SCRIPT"
echo "======================================"