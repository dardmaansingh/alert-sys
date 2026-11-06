const mongoose = require('mongoose');

const alertSchema = new mongoose.Schema({
  rule_id: {
    type: String,
    required: true,
    index: true
  },
  log_id: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'NetworkLog',
    default: null
  },
  viewed_by: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    default: null
  },
  alert_time: {
    type: Date,
    default: Date.now,
    index: true
  },
  alert_type: {
    type: String,
    required: true
  },
  severity: {
    type: String,
    required: true,
    enum: ['LOW', 'MEDIUM', 'HIGH', 'CRITICAL'],
    index: true
  },
  source_ip: {
    type: String,
    required: true,
    index: true
  },
  description: {
    type: String,
    required: true
  },
  status: {
    type: String,
    enum: ['GENERATED', 'STORED', 'VIEWED', 'CLOSED'],
    default: 'GENERATED',
    index: true
  }
}, {
  timestamps: true
});

const Alert = mongoose.model('Alert', alertSchema);

module.exports = Alert;
