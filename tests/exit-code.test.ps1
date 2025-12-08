Describe 'universal-intel-chipset-updater.ps1' {
    It 'should exit with code 0 after launching a new version' {
        # Define dummy functions for Pester to find and mock.
        function Show-Screen1 { }
        function Verify-ScriptHash { }
        function Invoke-WebRequest { }
        function Read-Host { }
        function Get-DownloadsFolder { }
        function Start-Process { }
        function Cleanup { }
        function Show-FinalCredits { }

        # Mock the behavior of the functions for this test case.
        Mock -CommandName Show-Screen1 { }
        Mock -CommandName Verify-ScriptHash { return $true }
        Mock -CommandName Get-DownloadsFolder { return '/tmp' }
        Mock -CommandName Start-Process { }
        Mock -CommandName Cleanup { }
        Mock -CommandName Show-FinalCredits { }

        # Mock the network call to simulate finding a newer version.
        Mock -CommandName Invoke-WebRequest {
            return @{ Content = "99.9-9999.99.99" } # A fake, newer version
        }

        # Mock user input to follow the "download and exit" code path.
        $userInput = @('N', 'Y', 'Y') # Prompts: Continue? -> N, Download? -> Y, Exit? -> Y
        $inputCounter = 0
        Mock -CommandName Read-Host {
            $response = $userInput[$inputCounter]
            $script:inputCounter++
            return $response
        }

        # Wrap the script execution in a function
        function Invoke-ScriptForTest {
            . ./src/universal-intel-chipset-updater.ps1
        }

        # Assert that the script attempts to exit with a code of '0'.
        Should -ScriptBlock ${function:Invoke-ScriptForTest} -Throw -ExceptionType ([System.Management.Automation.ExitException]) -WithMessage '0'
    }
}
