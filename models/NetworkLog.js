const mongoose = require('mongoose');

const networkLogSchema = new mongoose.Schema({
  event_time: {
    type: Date,
    required: true,
    index: true
  },
  source_ip: {
    type: String,
    required: true,
    index: true
  },
  destination_ip: {
    type: String,
    required: true,
    index: true
  },
  source_port: {
    type: Number,
    required: true
  },
  destination_port: {
    type: Number,
    required: true,
    index: true
  },
  protocol: {
    type: String,
    required: true,
    uppercase: true
  },
  packet_size: {
    type: Number,
    required: true
  },
  message: {
    type: String,
    required: true
  },
  bytes_transferred: {
    type: Number,
    default: 0
  },
  packet_count: {
    type: Number,
    default: 1
  },
  dns_query: {
    type: String,
    default: null
  },
  log_type: {
    type: String,
    default: null
  },
  ssid: {
    type: String,
    default: null
  },
  bssid: {
    type: String,
    default: null
  },
  client_mac: {
    type: String,
    default: null
  },
  access_point_id: {
    type: String,
    default: null
  },
  ap_location: {
    type: String,
    default: null
  },
  rssi_dbm: {
    type: Number,
    default: null
  },
  wifi_band: {
    type: String,
    default: null
  },
  wifi_channel: {
    type: Number,
    default: null
  },
  frame_type: {
    type: String,
    default: null
  },
  frame_subtype: {
    type: String,
    default: null
  },
  source_mac: {
    type: String,
    default: null
  },
  destination_mac: {
    type: String,
    default: null
  }
}, {
  timestamps: true
});

const NetworkLog = mongoose.model('NetworkLog', networkLogSchema);

module.exports = NetworkLog;
