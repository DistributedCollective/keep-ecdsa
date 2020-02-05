package net

import (
	"context"
	"github.com/ethereum/go-ethereum/common"

	"github.com/keep-network/keep-core/pkg/net"
	coreNet "github.com/keep-network/keep-core/pkg/net"
)

// TODO: This are temporary aliases which should be removed after we integrate
// this package into keep-core `net` package
type TransportIdentifier = coreNet.TransportIdentifier
type Message = coreNet.Message
type TaggedMarshaler = coreNet.TaggedMarshaler
type TaggedUnmarshaler = coreNet.TaggedUnmarshaler
type HandleMessageFunc = coreNet.HandleMessageFunc
type BroadcastProvider = coreNet.Provider
type BroadcastChannel = coreNet.BroadcastChannel

// Provider represents an entity that can provide network access.
//
// Providers expose the ability to get a named BroadcastChannel and an
// UnicastChannel established with a peer.
type Provider interface {
	BroadcastChannelFor(name string) (BroadcastChannel, error)

	UnicastChannelWith(peerID TransportIdentifier) (UnicastChannel, error)
	OnUnicastChannelOpened(handler func(channel UnicastChannel))

	GetTransportIdentifier(address common.Address) (net.TransportIdentifier, error)
}

// UnicastChannel represents a point-to-point channel to a peer. It allows
// channel peers to send messages on the channel (via Send), and to access a
// low-level receive chan that furnishes messages sent onto the UnicastChannel.
type UnicastChannel interface {
	// Send takes a message that can marshal itself to protobuf and unicasts m to
	// the peer through the UnicastChannel.
	Send(m TaggedMarshaler) error
	// Recv registers a handler function to be called upon receipt of a message
	// delivered through UnicastChannel.
	Recv(ctx context.Context, handler func(message net.Message))
	// SetUnmarshaler sets an unmarshaler that will unmarshal a given
	// type to a concrete object that can be passed to and understood by any
	// registered message handling functions. The unmarshaler should be a
	// function that returns a fresh object of type proto.TaggedUnmarshaler,
	// ready to read in the bytes for an object marked as type.
	//
	// The string type associated with the unmarshaler is the result of calling
	// Type() on a raw unmarshaler.
	SetUnmarshaler(unmarshaler func() TaggedUnmarshaler)
}
