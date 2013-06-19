module.exports = class EEError extends Error
  constructor: (@text)->
    super