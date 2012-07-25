omi = window.OwMuchIs ||= {}
omi.App =

  init: ->
    _.bindAll @
    return

  setRates: (@rates) ->
    @doConversion() if window.location.search?
    return

  doConversion: ->
    term = String(window.location.search).replace(/\+/ig, ' ').replace(/\?q=/ig, '').replace(/\//ig, '')
    console.log 'term', term
    $('input[type=search]').val term
    amount = Number term.match(/[0-9?.0-9]*/)
    currencyCodes = term.match /[a-z]{3}/ig
    base = currencyCodes[0].toUpperCase()
    final = geoplugin_currencyCode()
    if currencyCodes[1]?
      final = currencyCodes[1].toUpperCase()

    ratio = @rates.rates[final] * (1 / @rates.rates[base])
    convertedAmount = ratio * amount
    console.log @rates
    $("#result").html """
      <p><span class="number">#{accounting.formatMoney(amount)}</span><span class="currency-code">#{base}</span>
      is about
      <span class="number">#{accounting.formatMoney(convertedAmount)}</span><span class="currency-code">#{final}</span></p>
    """
    return

omi.App.init()