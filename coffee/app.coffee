omi = window.OwMuchIs ||= {}
omi.App =

  init: ->
    _.bindAll @
    $('form').bind 'submit', @submit
    return

  setRates: (@rates) ->
    if window.location.search?
      @doConversion String(window.location.search).replace(/\+/ig, ' ').replace(/\?q=/ig, '').replace(/\//ig, '')
    return

  submit: (e) ->
    e.preventDefault()
    @doConversion $('input').val()
    return

  doConversion: (term) ->
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
    $('.amount.base').html """
      <span class="currency-symbol">#{OwMuchIs.App.symbolFromCurrencyCode(base)}</span>#{accounting.formatMoney(amount, {format:'%v'})}<span class="currency-code">#{base}</span>
    """
    $('.amount.conversion').html """
      <span class="currency-symbol">#{OwMuchIs.App.symbolFromCurrencyCode(final)}</span>#{accounting.formatMoney(convertedAmount, {format:'%v'})}<span class="currency-code">#{final}</span>
    """
    return

  symbolFromCurrencyCode: (code) ->
    switch code
      when "JPY", "CNY"
        return "&yen;"
      when "GBP"
        return "&pound;"
      when "EUR"
        return "&euro;"
      else
        return "$"

omi.App.init()