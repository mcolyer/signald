# signald

Using the power of unix for home control.

### Getting Started

```
git clone git@github.com:mcolyer/signald.git
cd signald
bundle install
cp config.yml.example config.yml
sudo ./signald
```

#### Without root

This only works if arping is using libnet 1.1.5.

```
sudo apt-get install libcap2-bin
sudo setcap cap_net_raw+ep  /usr/sbin/arping
```

## Concepts

### Signals

The core of signald is tracking signals. It models all input as a binary
signal. For example the arp signal is true only when the configured arp
address is present on the network.

Currently implemented signals:
- arp - a useful proxy for an individual's presence by tracking their
  smartphone on your network.
- sunlight - useful to determine when you should turn your lights on.

### Events

Events allow you to combine multiple signals using logic which are evaluated
every time a signal changes state. This allows you to trigger actions when the
environment changes in an event based manner.

Note: Events are not yet implemented.

