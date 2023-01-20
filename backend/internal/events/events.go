package events

import (
	"github.com/asaskevich/EventBus"
)

var (
	bus = EventBus.New()
)

func Subscribe(topic string, fn interface{}) error {
	return bus.Subscribe(topic, fn)
}

func Publish(topic string, args ...interface{}) {
	bus.Publish(topic, args...)
}

func Unsubscribe(topic string, handler interface{}) error {
	return bus.Unsubscribe(topic, handler)
}

func SubscribeAsync(topic string, fn interface{}, transactional bool) error {
	return bus.SubscribeAsync(topic, fn, transactional)
}

func WaitAsync() {
	bus.WaitAsync()
}
