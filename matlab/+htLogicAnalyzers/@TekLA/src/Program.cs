using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Remoting;
using System.Text;
using System.Threading.Tasks;
using Tektronix.LogicAnalyzer.TpiNet;

namespace Tex
{
    class Program
    {
        static private string path = null;
        static private string export_aim = null;

        private ITlaSystem m_system = null;

        private EventHandler m_runStartHandler;
        private EventHandler m_runCompleteHandler;

        private string version = null;

        private Boolean running = false;

        public Program()
        {
            try
            {

                m_system = RemoteTlaSystem.Connect(path+"tex.config");
                version = m_system.SWVersion;
                Console.Write("Version: ");
                Console.WriteLine(version);

                SubscribeToTpiNetEvents();
            }
            catch
            {
                Console.WriteLine("Fail to connect to TLA or there is no configuration file");
                Console.ReadLine();
            }
        }

        public void Quit()
        {
            UnsubscribeFromTpiNetEvents();
        }

        public Boolean Check()
        {
            return m_system != null;
        }

        public void Run()
        {
            running = true;
            Console.WriteLine("Run trigering...");
            m_system.RunControl.Run();
            while (running) ;
        }

        private void SubscribeToTpiNetEvents()
        {
            m_runStartHandler = EventRemoter.Create(new EventHandler(OnRunStarted));
            m_system.RunControl.RunStarted += m_runStartHandler;

            m_runCompleteHandler = EventRemoter.Create(new EventHandler(OnRunCompleted));
            m_system.RunControl.RunCompleted += m_runCompleteHandler;
        }

        private void UnsubscribeFromTpiNetEvents()
        {
            
            m_system.RunControl.RunStarted -= m_runStartHandler;
            m_system.RunControl.RunCompleted -= m_runCompleteHandler;

            m_runStartHandler = null;
            m_runCompleteHandler = null;
        }

        private void ExportData()
        {
            Boolean flag = false;
            Console.WriteLine("Searching list window...");
            ArrayList list = m_system.DataWindows;
            foreach(Object obj in list)
            {
                IListingWindow window = obj as IListingWindow;
                if(window != null)
                {
                    if (window.UserName.CompareTo(export_aim) == 0)
                    {
                        Console.Write("Aim list window found, exporting to: ");
                        Console.WriteLine(path+"tex.txt");
                        flag = true;
                        try
                        {
                            window.Export(path+"tex.txt", null);
                        }
                        catch
                        {
                            Console.WriteLine("File error!");
                            Console.ReadLine();
                        }
                        break;
                    }
                    
                }
            }
            if (!flag)
            {
                Console.Write("Fail to find window: ");
                Console.WriteLine(export_aim);
                Console.ReadLine();
            }
        }

        private void OnRunStarted(object sender, EventArgs args)
        {
            Console.WriteLine("TLA is running...");
        }

        // Event handler for the ITlaRunControl.RunCompleted event.
        private void OnRunCompleted(object sender, EventArgs args)
        {
            Console.WriteLine("TLA run completed!");
            running = false;
        }

        static void Main(string[] args)
        {
            Boolean run_flag = false;
            Boolean export_flag = false;
            if (args.Length < 2) {
                Console.WriteLine("Too few arguments!");
                Console.ReadLine();
                return;
            }
            else
            {
                path = args[0];
                if (args[1].Contains("r"))
                {
                    run_flag = true;
                }
                if (args[1].Contains("e"))
                {
                    export_flag = true;
                }
            }
            if(export_flag && args.Length < 3)
            {
                Console.WriteLine("Too few arguments for export!");
                return;
            }
            else if(export_flag)
            {
                export_aim = args[2];
            }
            
            try
            {
                Program prog = new Program();
                if (prog.Check())
                {
                    if (run_flag)
                    {
                        prog.Run();
                    }
                    if (export_flag)
                    {
                        prog.ExportData();
                    }
                }
                prog.Quit();
            }
            catch
            {
                Console.WriteLine("The remote TPI.NET client experienced an error and must shut down.");
                Console.ReadLine();
            }
        }
    }
}
