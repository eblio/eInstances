# eAnimenu
A FiveM script written in LUA allowing you to manage separate worlds among players.

## API

### Exports

The **identifier of an instance has to be a string** otherwise the call will most likely be ignored.

| Name | Action | Example |
| --- | --- | --- |
| EnterInstance(id) | Make the player enter an instance. | `exports.eInstances:EnterInstance('apt:1')` |
| LeaveInstance() | Make the player leave current instance. | `exports.eInstances:LeaveInstance()` |

### Events

#### Client

| Name | Note |
| --- | --- |
| `instance:entered` | Triggered when someone enters an instance. Sends the identifier of the instance. |
| `instance:left` | Triggered when someone leaves an instance. Sends The identifier of the instance. |
| `instance:wasInInstance` | Triggered when someone reconnects after disconnecting in an instance. Sends The identifier of the instance. |

#### Server

| Name | Note |
| --- | --- |
| `instance:entered` | Triggered when someone enters an instance. Sends The identifier of the instance. |
| `instance:left` | Triggered when someone leaves an instance. Sends The identifier of the instance. |

*Note : you may want to use those events to split people in different channels accordingly to your voice system.*
