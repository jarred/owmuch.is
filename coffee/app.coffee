omi = window.OwMuchIs ||= {}
omi.App =

  init: ->
    _.bindAll @
    $('form').bind 'submit', @submit
    # $('form').bind 'keyup', @submit
    accounting.settings.currency.format = '<span class="currency-symbol">%s</span>%v'
    # $('#input').bind 'keypress', @submit
    $('input').focus()
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
    $('input[type=search]').val term
    amount = Number term.match(/[0-9?.0-9]*/)
    currencyCodes = term.match /[a-z]{3}/ig
    return if currencyCodes is null
    base = currencyCodes[0].toUpperCase()
    final = geoplugin_currencyCode()
    if currencyCodes[1]?
      final = currencyCodes[1].toUpperCase()

    ratio = @rates.rates[final] * (1 / @rates.rates[base])
    convertedAmount = ratio * amount

    $('.amount.base').html """
      #{accounting.formatMoney(amount, OwMuchIs.App.symbolFromCurrencyCode(base))}<span class="currency-code">#{base}</span>
    """
    $('.amount.conversion').html """
      #{accounting.formatMoney(convertedAmount, OwMuchIs.App.symbolFromCurrencyCode(final))}<span class="currency-code">#{final}</span>
    """

    _gaq.push(['_trackEvent', 'Conversion', 'Do']);
    _gaq.push(['_trackEvent', 'Conversion', 'base', base]);
    _gaq.push(['_trackEvent', 'Conversion', 'final', final]);
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