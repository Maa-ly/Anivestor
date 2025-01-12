// "use client"
// import { IExecOracleFactory, ParamSet } from "@iexec/iexec-oracle-factory-wrapper";

// const web3Provider = window.ethereum;
// // instantiate
// const factory = new IExecOracleFactory(web3Provider);

// // create an observable
// const createOracleObservable = factory.createOracle({
//    url: "https://data.chain.link/api/query?query=FEED_DATA_QUERY&variables=%7B%22schemaName%22%3A%22ethereum-mainnet%22%2C%22contractAddress%22%3A%220xc9e1a09622afdb659913fefe800feae5dbbfe9d7%22%7D",
//    method: "GET",
//    dataType: "number",
//    JSONPath: "$.data.chainData.nodes.inputs.answer",
//    // apiKey: 'MY_TEST_API_KEY',
// });

// // subscribe to the observable and start the workflow
// createOracleObservable.subscribe({
//    next: (data) => {
//       console.log("next", data);
//    },
//    error: (error) => {
//       console.log("error", error);
//    },
//    complete: () => {
//       console.log("Oracle Creation Completed");
//    },
// });

// const paramSet: ParamSet = {
//    url: "https://data.chain.link/api/query?query=FEED_DATA_QUERY&variables=%7B%22schemaName%22%3A%22ethereum-mainnet%22%2C%22contractAddress%22%3A%220xc9e1a09622afdb659913fefe800feae5dbbfe9d7%22%7D",
//    method: "GET",
//    dataType: "number",
//    JSONPath: "$.data.chainData.nodes.inputs.answer",
// };

// const value = factory.readOracle(paramSet);
// console.log(value);

// export { value };
