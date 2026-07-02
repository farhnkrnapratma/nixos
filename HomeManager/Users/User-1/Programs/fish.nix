let
  env = fromTOML (builtins.readFile ../../../../env.toml);
in
{
  programs.fish = {
    enable = true;
    generateCompletions = true;
    shellAliases = {
      c = "clear";
      l = "eza -lahgmuU --smart-group --icons=always --color=always --color-scale --color-scale-mode=gradient";
      x = "exit";
      ga = "git add -A";
      gc = "git commit -s -m";
      gp = "git push";
      ls = "eza --icons=always --color=always --color-scale --color-scale-mode=gradient";
      ".." = "cd ..";
      "..." = "cd ../..";
    };
    interactiveShellInit = ''
      function fish_greeting
        fastfetch
      end

      function commit
        if not git rev-parse --is-inside-work-tree >/dev/null 2>&1
          echo "(!) Not in a git repository"
          return 1
        end

        set -l cmsg $argv[1]
        set -l mode $argv[2]
        set -l files $argv[3..-1]

        if test -z "$cmsg"
          echo "(!) Commit messages cannot be empty"
          return 1
        end

        test -n "$mode"; or set mode a

        echo "(1/3) Staging changes..."
        switch $mode
          case a
            if not git add -A
              echo "(!) Failed at [1/3]"
              return 1
            end
          case f
            if test (count $files) -eq 0
              echo "(!) No files specified"
              return 1
            end
            for f in $files
              if not test -e "$f"
                echo "(!) File not found: $f"
                return 1
              end
            end
            if not git add $files
              echo "(!) Failed at [1/3]"
              return 1
            end
          case '*'
            echo "(!) Invalid mode: $mode"
            return 1
        end

        echo "(2/3) Committing staged changes..."
        if not git commit -s -m "$cmsg"
          echo "(!) Failed at [2/3]"
          return 1
        end

        echo "(3/3) Pushing commits..."
        just push
      end

      function devel
        set -l cmd -c fish -i

        if not test -f "flake.nix"
          echo "(!) No 'flake.nix' file found in the working directory"
          return 1
        else
          nix develop $cmd
        end
      end

      function shell
        if test -f "flake.nix"; and test (count $argv) -eq 0
          nix shell
        else if test (count $argv) -eq 0
          echo "(!) No packages specified and no 'flake.nix' file found in the working directory"
          return 1
        else
          set -l pkgs
          for pkg in $argv
            if string match -q "nixpkgs#*" $pkg
              set pkgs $pkgs $pkg
            else
              set pkgs $pkgs "nixpkgs#$pkg"
            end
          end
          nix shell $pkgs
        end
      end

      function update
        set -l cwd (pwd)
        set -l update false

        echo "(1/5) cd '$cwd' -> '${env.path.flake}'"
        if not cd ${env.path.flake}
          echo "(!) Failed at (1/5)"
          return 1
        end

        echo "(2/5) Updating flakes..."
        just update

        git diff --quiet -- flake.lock; or set update true

        if test "$update" = true
          echo "(3/5) Rebuilding system..."
          if not just rebuild
            echo "(!) Failed at (3/5)"
            cd $cwd 2>/dev/null
            return 1
          end

          echo "(4/5) Cleaning generations..."
          just clean

          echo "(5/5) Pushing lockfile update..."
          commit "flake(lock): update flake inputs" f "flake.lock"
        else
          echo "(i) No flakes update available. Skipping rebuild."
        end

        cd $cwd
      end
    '';
  };
}
