import Ajv, { JTDDataType } from "ajv/dist/jtd";
const ajv = new Ajv();

const schema = {
  properties: {
    foo: { type: "int32" },
  },
  optionalProperties: {
    bar: { type: "string" },
  },
} as const;

type MyData = JTDDataType<typeof schema>;

// type inference is not supported for JTDDataType yet
const validate = ajv.compile<MyData>(schema);

const validData = {
  foo: 1, // use 1.4 for error branch
  bar: "abc",
};

if (validate(validData)) {
  // data is MyData here
  console.log(validData.foo);
} else {
  console.log(validate.errors);
}
