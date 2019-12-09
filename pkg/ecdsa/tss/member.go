package tss

import (
	"math/big"
)

// MemberID is an unique identifier of a member across the network.
type MemberID string

func (id MemberID) bigInt() *big.Int {
	return new(big.Int).SetBytes([]byte(id))
}

// GroupInfo holds information about the group selected for protocol execution.
type GroupInfo struct {
	groupID        string // globally unique group identifier
	memberID       MemberID
	groupMemberIDs []MemberID
}
