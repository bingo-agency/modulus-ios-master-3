//import _ from 'lodash';
//import moment from 'moment';
//
//import historyProvider from './historyProvider.js';
//import { signalRUrl, signalRDataHub } from 'setup';
//import { store } from 'redux/store';

//const { $ } = window;

const { $ } = window;
var to ='ETH';
var base='BTC';
var store = Redux.createStore(counter)
var connection = $.hubConnection(domain);
var dataTickerHubProxy = connection.createHubProxy('dataTickerHub');
function counter(state, action) {
    if (typeof state === 'undefined') {
        return 0
    }
    switch (action.type) {
        case 'INCREMENT':
            return state + 1
        case 'DECREMENT':
            return state - 1
        default:
            return state
    }
}



connection.start().done(function () {
                        console.log('\n-------------------------   Start the connection to the dataTickerHub    ---------------------------');
//                        datafeed
//                        subscribeBars()
                        console.log(subscriptionBarsInfo)
                        if (subscriptionBarsInfo){
                            streamProvider.subscribeBars(subscriptionBarsInfo.symbolInfo, subscriptionBarsInfo.resolution, subscriptionBarsInfo.updateCb, subscriptionBarsInfo.uid, subscriptionBarsInfo.resetCache)
                        }
//                        addTradingViewWidget();
//                        dataTickerHubProxy.invoke('joinGroup', 'ETH', 'BTC');
//                        dataTickerHubProxy.invoke('subscribeToChartTicker', 'BAT', 'BTC',1);
                        //    dataTickerHubProxy.invoke('subscribeTo_PendingOrderData', 'USER_UNIQUE_ACCESS_TOKEN', 'TRADE_CURRENCY', 'MARKET_CURRENCY');
                        });


dataTickerHubProxy.on('pushDataAllChart', function (data) {
                      console.log('\n--- gets chart data ----');
                      console.table(data);
//                      const barData = JSON.parse(data[0]);
                      const barData = data[0]
                      barData.open = 0.8
//                      barData.close  0.8
                      console.log(barData)
                      if (subscription) {
                      if (barData.time < subscription.lastBar.time) {
                      return;
                      }
                      
                      const lastBar = updateBar(barData, subscription);
                      
                      subscription.listener(lastBar);
                      // update our own record of lastBar
                      subscription.lastBar = lastBar;
                      }
                      });

dataTickerHubProxy.on('chartTicker', function (data) {
                      console.log('\n--- get real-time updates to chart data both---');
                      console.table(data);
                      });
let subscription = {};
let subscriptionBarsInfo = {};
window.dataTickerHubProxy = dataTickerHubProxy;

const streamProvider = {
//    const symbolInfoData
    
  subscribeBars:async (symbolInfo, resolution, updateCb, uid, resetCache) => {
    
      subscriptionBarsInfo = {symbolInfo, resolution, updateCb, uid, resetCache};
      
    const [baseCurrency, quoteCurrency] = symbolInfo.name.split('/');
    const lastBar = _.get(historyProvider, `history.${symbolInfo.name}.lastBar`, {
      time: moment().startOf('m').valueOf(),
      open: 0,
      close: 0,
      hight: 0,
      low: 0,
      volume: 0
    })
      console.log('Subscribing to bars ------'+symbolInfo.name)
//    console.log(baseCurrency)
      
      
      
      dataTickerHubProxy.invoke(
                                'joinGroup',
                                baseCurrency,
                                quoteCurrency,
                                10,
                                ).done(function () {
                                       console.log('Group has been joined')
                                       
                                       
                                       }).fail(function() {
                                               alert("Could not join group!");
                                               });
      
    dataTickerHubProxy.invoke(
      'subscribeToChartTicker',
      baseCurrency,
      quoteCurrency,
                              1).done(function () {
                                      console.log('Subscribed to chart ticker')
                                      
                                      
                                      }).fail(function() {
                                              alert("Could not subcriber to chart ticker!");
                                              });

    subscription = {
      channel: `${baseCurrency}${quoteCurrency}1`,
      uid,
      resolution,
      symbolInfo,
      listener: updateCb,
      lastBar,
    };
      console.log('Update exchange: ', store.getState().exchange);
//    const { lastPrice } = store.getState().exchange.tradingPairStats;
//    updatePrice(lastPrice)

  },
  unsubscribeBars: uid => {},
};

dataTickerHubProxy.on('chartTicker', data => {
  console.log('Chart Tickers data')
  const barData = JSON.parse(data.Data);

  if (subscription) {
    if (barData.time < subscription.lastBar.time) {
      return;
    }

    const lastBar = updateBar(barData, subscription);

    subscription.listener(lastBar);
    // update our own record of lastBar
    subscription.lastBar = lastBar;
  }
});

dataTickerHubProxy.on('pushDataTickerMatched', data => {
  updateVolume(data.Data);
})



 const updateVolume = ticker => {
  if (!_.isEmpty(subscription)) {
    let lastBar = subscription.lastBar;

    lastBar.volume += ticker.Volume;
    subscription.listener(lastBar);
  }
}

 const updatePrice = price => {
  if (!_.isEmpty(subscription)) {
    let lastBar = subscription.lastBar;
    if (price < lastBar.low) {
      lastBar.low = price;
    } else if (price > lastBar.high) {
      lastBar.high = price;
    }

    lastBar.close = price;

    subscription.listener(lastBar)
  }
};

// Take a single trade, and subscription record, return updated bar
const updateBar = (barData, subscription) => {
  let lastBar = subscription.lastBar;
  let resolution = subscription.resolution;

  if (resolution.includes('D')) {
    // 1 day in minutes === 1440
    resolution = 1440;
  } else if (resolution.includes('W')) {
    // 1 week in minutes === 10080
    resolution = 10080;
  }

  let coeff = resolution * 60 * 1000;
  // console.log({coeff})
  let isSameInterval =
    Math.floor(barData.time / coeff) === Math.floor(lastBar.time / coeff);
  let _lastBar;

  if (!isSameInterval) {
    // create a new candle, use last close as open **PERSONAL CHOICE**
    _lastBar = {
      time: barData.time,
      open: lastBar.close,
      high: lastBar.close,
      low: lastBar.close,
      close: barData.close,
      volume: barData.volume,
    };
  } else {
    // update lastBar candle!
    if (barData.close < lastBar.low) {
      lastBar.low = barData.close;
    } else if (barData.close > lastBar.high) {
      lastBar.high = barData.close;
    }

    lastBar.volume += barData.volume;
    lastBar.close = barData.close;
    _lastBar = lastBar;
  }

  return _lastBar;
};


//const { $ } = window;
//var to ='ETH';
//var base='BTC';
//
//var connection = $.hubConnection('https://api.modulusexchange.com');
//var dataTickerHubProxy = connection.createHubProxy('dataTickerHub');
//
//
//dataTickerHubProxy.on('chartTicker', function (data) {
//                      console.log('\n--- gets chart data ----');
//                      console.table(data);
//                      });
//connection.start().done(function () {
//                        console.log('\n-------------------------   Start the connection to the dataTickerHub    ---------------------------');
//                        dataTickerHubProxy.invoke('joinGroup', 'ETH', 'BTC');
//                        dataTickerHubProxy.invoke('subscribeToChartTicker', 'ETH', 'BTC',1440);
//                        //    dataTickerHubProxy.invoke('subscribeTo_PendingOrderData', 'USER_UNIQUE_ACCESS_TOKEN', 'TRADE_CURRENCY', 'MARKET_CURRENCY');
//                        });
//
//
//let subscription = {};
//window.dataTickerHubProxy = dataTickerHubProxy;
//
//const streamProvider = {
//subscribeBars: (symbolInfo, resolution, updateCb, uid, resetCache) => {
//    const [baseCurrency, quoteCurrency] = symbolInfo.name.split('/');
//    const lastBar={};
//    // const lastBar = _.get(historyProvider, `history.${symbolInfo.name}.lastBar`, {
//    //   time: moment().startOf('m').valueOf(),
//    //   open: 0,
//    //   close: 0,
//    //   hight: 0,
//    //   low: 0,
//    //   volume: 0
//    // })
//
//    dataTickerHubProxy.invoke(
//                              'subscribeToChartTicker',
//                              baseCurrency,
//                              quoteCurrency,
//                              1,
//                              );
//
//    dataTickerHubProxy.invoke(
//                              'joinGroup',
//                              baseCurrency,
//                              quoteCurrency,
//                              10,
//                              );
//
//    subscription = {
//    channel: `${baseCurrency}${quoteCurrency}1`,
//        uid,
//        resolution,
//        symbolInfo,
//    listener: updateCb,
//        lastBar,
//    };
//
//    const { lastPrice } = store.getState().exchange.tradingPairStats;
//
//    updatePrice(lastPrice)
//
//},
//unsubscribeBars: uid => {},
//};
//
//dataTickerHubProxy.on('chartTicker', data => {
//                      const barData = JSON.parse(data.Data);
//
//                      if (subscription) {
//                      if (barData.time < subscription.lastBar.time) {
//                      return;
//                      }
//
//                      const lastBar = updateBar(barData, subscription);
//
//                      subscription.listener(lastBar);
//                      // update our own record of lastBar
//                      subscription.lastBar = lastBar;
//                      }
//                      });
//
//dataTickerHubProxy.on('pushDataTickerMatched', data => {
//                      updateVolume(data.Data);
//                      })
//
//const updateVolume = ticker => {
//    if (!_.isEmpty(subscription)) {
//        let lastBar = subscription.lastBar;
//
//        lastBar.volume += ticker.Volume;
//        subscription.listener(lastBar);
//    }
//}
//
//const updatePrice = price => {
//    if (!_.isEmpty(subscription)) {
//        let lastBar = subscription.lastBar;
//        if (price < lastBar.low) {
//            lastBar.low = price;
//        } else if (price > lastBar.high) {
//            lastBar.high = price;
//        }
//
//        lastBar.close = price;
//
//        subscription.listener(lastBar)
//    }
//};
//
//// Take a single trade, and subscription record, return updated bar
//const updateBar = (barData, subscription) => {
//    let lastBar = subscription.lastBar;
//    let resolution = subscription.resolution;
//
//    if (resolution.includes('D')) {
//        // 1 day in minutes === 1440
//        resolution = 1440;
//    } else if (resolution.includes('W')) {
//        // 1 week in minutes === 10080
//        resolution = 10080;
//    }
//
//    let coeff = resolution * 60 * 1000;
//    // console.log({coeff})
//    let isSameInterval =
//    Math.floor(barData.time / coeff) === Math.floor(lastBar.time / coeff);
//    let _lastBar;
//
//    if (!isSameInterval) {
//        // create a new candle, use last close as open **PERSONAL CHOICE**
//        _lastBar = {
//        time: barData.time,
//        open: lastBar.close,
//        high: lastBar.close,
//        low: lastBar.close,
//        close: barData.close,
//        volume: barData.volume,
//        };
//    } else {
//        // update lastBar candle!
//        if (barData.close < lastBar.low) {
//            lastBar.low = barData.close;
//        } else if (barData.close > lastBar.high) {
//            lastBar.high = barData.close;
//        }
//
//        lastBar.volume += barData.volume;
//        lastBar.close = barData.close;
//        _lastBar = lastBar;
//    }
//
//    return _lastBar;
//};
//
////module.exports.streamProvier=streamProvier;
