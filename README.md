# Elasticsearch Indexing and Querying

## Overview

This project demonstrates basic data indexing and querying using Elasticsearch.

The exercise consists of creating an index for a structured pizza dataset, defining custom mappings, loading data in bulk, and running analytical queries using Elasticsearch Query DSL.

---

## Technologies Used

- Elasticsearch
- REST API
- Query DSL
- Bulk API
- JSON
- Shell / cURL

---

## Implemented Features

- Verification of Elasticsearch service availability
- Index creation with custom mappings
- Bulk ingestion of JSON documents
- Range queries over numeric fields
- Term and boolean queries over text fields
- Update and delete operations on indexed documents
- Document count validation

---

## Dataset

The dataset contains information about pizzas, including:

- Pizza name
- Toppings
- Dough type
- Pizza size/type
- Price

---

## Example Operations

- Search pizzas within a given price range
- Filter pizzas by dough type
- Retrieve the cheapest pizza
- Update a document field
- Delete a specific indexed document

---

## Repository Structure

```text
elasticsearch-indexing/
│
├── data/       # JSON dataset
├── scripts/    # Elasticsearch commands / setup
├── docs/       # Supporting documentation
└── README.md
