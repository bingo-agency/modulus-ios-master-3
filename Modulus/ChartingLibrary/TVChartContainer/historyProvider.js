//import axios from 'axios';
//import moment from 'moment';
//import qs from 'qs';
//import { backendUrl } from 'setup';

const history = {};

const resolutions = {
  '1': '1',
  '5': '5',
  '15': '15',
  '30': '15',
  '60': '60',
  '240': '60',
  'D': '1440',
}

const historyProvider = {
  history: history,

    

 getBars: (symbolInfo, resolution, from, to, first, limit) => {
     
//     window.setTimeout( function(){  //acting like this is an Ajax call
                       try {
                       result =  $.ajax({
                                        
                                        url : 'https://api.modulusexchange.com/market/get-chart-data?baseCurrency=BTC&quoteCurrency=ETH&interval=60&limit=200&timestamp=1541228704517',
                                        type : 'GET',
                                        data : {
                                        },
                                        dataType:'json',
                                        success : function(data) {
                                        alert('Data: '+data);
                                        console.log(data)
                                        if (data.data.length) {
                                        const bars = data.data.map(bar => {
                                                                   delete bar.ID;
                                                                   return bar
                                                                   })
//                                                                   return {
//                                                                   ...bar,
//                                                                   time: moment(bar.time).valueOf(),
//                                                                   }})
                                        
                                        if (first) {
                                        const lastBar = bars[0];
                                        history[symbolInfo.name] = { lastBar }
                                        }
                                        console.log('BARS:'+bars)
                                        return bars.reverse();
                                        }else{
                                        console.log('Data is empty')
                                        return [];
                                        }
                                        },
                                        error : function(request,error)
                                        {
                                        alert("Request: "+JSON.stringify(request));
                                        }
                                        });
                       } catch (error) {
                        console.error(error);
                       }
//                       },2000);

  },
};



//module.exports.historyProvider=historyProvider;
