module.exports = function (results) {
  const lintResults = [];
  results.forEach((result) => {
    if (result.messages.length) {
      lintResults.push(
        ...result.messages.map((message) => {
          return {
            filename: result.filePath,
            text: message.message,
            lnum: message.line,
            col: message.column,
            severity: message.severity,
          };
        }),
      );
    }
  });
  return JSON.stringify(lintResults);
};
