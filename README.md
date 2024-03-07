Worktree

Overview
Worktree is a convenient and user-friendly wrapper around git worktree. It simplifies the process of managing git worktrees by providing easy-to-use commands to select, create, remove, and list local worktrees. Additionally, it streamlines the process of navigating between branches associated with these worktrees.

Features
Create Worktree: Quickly create new worktrees for different branches, you can search through remote branches.
Remove Worktree: Easily remove obsolete worktrees that are no longer needed by selecting them from a list or by typing in the name.
List Worktrees: View a list of local worktrees and switch to them.

Installation
To use worktree, follow these simple steps:

Clone the repository:

```bash
git clone https://github.com/enipo/worktree-tool.git
```

Navigate to the project directory:

```bash
cd worktree-tool
```

Install the script
```bash
make install
```

Or uninstall the script (don't do both or you'll end up with nothing)
```bash
make uninstall
```

Usage
Git Worktree Manager provides the following commands:

create: Create a new worktree for the specified branch.
select: Select an existing worktree and switch to its associated branch.
remove: Remove an obsolete worktree and its associated branch.
list: List all local worktrees and their associated branches.

Examples:

```bash
Usage: wo [command] [branch_name]
Commands:
  g     - Go back to the main folder
  c     - Create a worktree for the specified branch
  r     - Remove the worktree for the specified branch
  l     - List existing worktrees
  init  - Initialize worktree
```

Contributing
Contributions are welcome! If you'd like to contribute to Worktree, please follow our Contribution Guidelines.

License
This project is licensed under the [CC0 1.0 Universal (CC0 1.0) Public Domain Dedication](LICENSE).

Feel free to replace placeholders like your-username and your-repo with the appropriate details for your GitHub repository. Additionally, consider adding more details, such as usage examples or advanced configuration options, based on the complexity of your project.
