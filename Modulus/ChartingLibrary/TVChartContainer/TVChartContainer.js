import * as React from 'react';
import { connect } from 'react-redux';
import { withTheme } from 'styled-components';
import _ from 'lodash';
import { widget } from '../../charting_library/charting_library.min';

import datafeed from './datafeed';
import { updatePrice } from './streamProvider';

class TVChartContainer extends React.PureComponent {
  state = {
    isChartReady: false,
  };

  static defaultProps = {
    symbol: '/',
    interval: '5',
    containerId: 'tv_chart_container',
    datafeedUrl: 'https://demo_feed.tradingview.com',
    libraryPath: '/charting_library/',
    chartsStorageUrl: 'https://saveload.tradingview.com',
    chartsStorageApiVersion: '1.1',
    clientId: 'tradingview.com',
    userId: 'public_user_id',
    fullscreen: false,
    autosize: true,
    studiesOverrides: {},
  };

  tvWidget = null;

  initializeTradingView() {
    const { tradingPair } = this.props;

    const widgetOptions = {
      symbol: `${tradingPair.baseCurrency}/${tradingPair.quoteCurrency}`,
      datafeed: datafeed,
      interval: this.props.interval,
      container_id: this.props.containerId,
      library_path: this.props.libraryPath,

      locale: 'en',
      disabled_features: ['use_localstorage_for_settings'],
      enabled_features: ['study_templates'],
      charts_storage_url: this.props.chartsStorageUrl,
      charts_storage_api_version: this.props.chartsStorageApiVersion,
      client_id: this.props.clientId,
      user_id: this.props.userId,
      fullscreen: this.props.fullscreen,
      autosize: this.props.autosize,
      studies_overrides: this.props.studiesOverrides,
      theme: this.props.theme.chartingTheme,
    };

    const tvWidget = new widget(widgetOptions);
    this.tvWidget = tvWidget;

    tvWidget.onChartReady(() => {
      this.setState({ isChartReady: true });
      // const button = tvWidget
      //   .createButton()
      //   .attr('title', 'Click to show a notification popup')
      //   .addClass('apply-common-tooltip')
      //   .on('click', () =>
      //     tvWidget.showNoticeDialog({
      //       title: 'Notification',
      //       body: 'TradingView Charting Library API works correctly',
      //       callback: () => {
      //         console.log('Noticed!');
      //       },
      //     }),
      //   );
      // button[0].innerHTML = 'Check API';
    });
  }

  componentDidMount() {
    const { tradingPair } = this.props;
    if (!_.isEmpty(tradingPair)) {
      this.initializeTradingView();
    }
  }

  componentWillUnmount() {
    if (this.tvWidget !== null) {
      if (this.state.isChartReady) {
        this.tvWidget.remove();
      } else {
        this.tvWidget.onChartReady(() => {
          this.tvWidget.remove();
        });
      }
    }
    this.tvWidget = null;
  }

  setTradingPair() {
    const { interval } = this.tvWidget.symbolInterval();
    const tradingPair = `${this.props.tradingPair.baseCurrency}/${
      this.props.tradingPair.quoteCurrency
    }`;
    this.tvWidget.setSymbol(tradingPair, interval);
  }

  componentDidUpdate(prevProps) {
    if (!_.isEqual(prevProps.tradingPair, this.props.tradingPair)) {
      if (this.tvWidget === null) {
        this.initializeTradingView();
      } else {
        if (this.state.isChartReady) {
          this.setTradingPair();
        } else {
          this.tvWidget.onChartReady(() => {
            this.setTradingPair();
          });
        }
      }
    }

    updatePrice(this.props.lastPrice);
  }

  render() {
    return (
      <div
        id={this.props.containerId}
        className={'TVChartContainer'}
        style={{
          flex: '1 1 0%',
          height: '100%',
        }}
      />
    );
  }
}

const mapStateToProps = ({ exchange }) => ({
  tradingPair: exchange.tradingPair,
  lastPrice: exchange.tradingPairStats.lastPrice,
});

export default withTheme(connect(mapStateToProps)(TVChartContainer));
