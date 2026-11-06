const mongoose = require('mongoose');

const ruleSchema = new mongoose.Schema({
  rule_id: {
    type: String,
    required: true,
    unique: true
  },
  rule_name: {
    type: String,
    required: true
  },
  rule_type: {
    type: String,
    required: true,
    enum: ['HIGH_TRAFFIC', 'HIGH_DNS_ACTIVITY', 'PORT_SCAN']
  },
  threshold_value: {
    type: Number,
    required: true
  },
  window_seconds: {
    type: Number,
    required: true
  },
  severity: {
    type: String,
    required: true,
    enum: ['LOW', 'MEDIUM', 'HIGH', 'CRITICAL']
  },
  is_active: {
    type: Boolean,
    default: true
  },
  cooldown_seconds: {
    type: Number,
    default: 60
  }
}, {
  timestamps: true
});

const Rule = mongoose.model('Rule', ruleSchema);

module.exports = Rule;
