const std = @import("std");

// Indentifies common character states
const CombatStateID = enum(u32) {
    Standing,
    Crounching,
    WalkingForward,
    WalkingBackwards,
    Jump,
    _,
};

// Provides an interface for combat states to respond to various events
const CombatStateCallbacks = struct {
    OnStart: fn() void = undefined,     // Called when starting an action
    OnUpdate: fn() void = undefined,    // Called every frame
    OnEnd: fn() void = undefined,       // Called when finishing an action
};


const CombatStateRegistry = struct {
    const MAX_STATES = 256;
    CombatStates: [MAX_STATES]?*const CombatStateCallbacks = [_]?* const CombatStateCallbacks {null} ** MAX_STATES,

    pub fn RegisterCommonState(self: *CombatStateRegistry, StateID: CombatStateID, StateCallbacks: *const CombatStateCallbacks) void {
        // TODO: assert(StateID <= LastCommonStateID) in a zig way
        self.CombatStates[@intFromEnum(StateID)] = StateCallbacks;
    }
};

const StateExecutor = struct {
    StateRegistry: CombatStateRegistry,
};

// It doesn't work
test "Register a combat state" {
    var Registry = CombatStateRegistry {};
    var TestState = CombatStateCallbacks {};

    try std.testing.expect(Registry.CombatStates[0] == null);

    Registry.RegisterCommonState(CombatStateID.Standing, &TestState);

    try std.testing.expect(Registry.CombatStates[0] != null);
}
