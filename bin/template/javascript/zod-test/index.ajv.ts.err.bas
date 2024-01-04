[
  {
    instancePath: '/id',
    schemaPath: '#/properties/id/minimum',
    keyword: 'minimum',
    params: { comparison: '>=', limit: 10 },
    message: 'must be >= 10',
    schema: 10,
    parentSchema: { type: 'integer', minimum: 10 },
    data: 1
  }
]
[
  {
    instancePath: '/results/0/id',
    schemaPath: '#/properties/results/items/properties/id/minimum',
    keyword: 'minimum',
    params: { comparison: '>=', limit: 10 },
    message: 'must be >= 10',
    schema: 10,
    parentSchema: { type: 'integer', minimum: 10 },
    data: 1
  }
]
